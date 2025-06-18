#include <array>
#include <future>

#include "webgpu/webgpu.h"
#include "spdlog/spdlog.h"
/*
 * Approximate GELU kernel definition, implemented as a WGSL.
 * In general GPU device code for WEBGPU is written in the WGSL domain specific
 * language.
 *
 * Here inp and out correspond to bindings 0 and 1 respectively. In the main
 * code, we create buffers for these bindings and populate them with data.
 *
 */
const char *kShaderGELU = R"(
const GELU_SCALING_FACTOR: f32 = 0.7978845608028654; // sqrt(2.0 / PI)
@group(0) @binding(0) var<storage, read_write> inp: array<f32>;
@group(0) @binding(1) var<storage, read_write> out: array<f32>;
@compute @workgroup_size(256)
fn main(
    @builtin(global_invocation_id) GlobalInvocationID: vec3<u32>) {
    let i: u32 = GlobalInvocationID.x;
    // Ensure we do not access out of bounds
    if (i < 3072) {
        let x: f32 = inp[i];
        let cube: f32 = 0.044715 * x * x * x;
        out[i] = select(0.5 * x * (1.0 + tanh(GELU_SCALING_FACTOR
                 * (x + .044715 * x * x * x))), x, x > 10.0);
    }
}
)";

/*
 * Convenience function to check if a condition is true, if not log an error
 * message and exit.
 *
 * @param condition: The condition to check.
 * @param message: The error message to log if the condition is false.
 * @param file: The file where the error occurred.
 * @param line: The line where the error occurred.
 */
inline void check(bool condition, const char *message,
                  const char *file = "unkown", int line = -1) {
  if (!condition) {
    spdlog::error("Error in file {} line {}:\n{}", file, line, message);
    exit(1);
  } else {
    spdlog::trace("Success in file {} line {}:\n{}", file, line, message);
  }
}

/*
 * Convenience function to display the first few elements of an array. A more
 * robust/extensive version of this is in array_utils.hpp this is minimal to keep
 * this example self-contained.
 *
 * @param a: The array to show.
 * @param name: The name of the array.
 * @return: A string representation of the array.
 */
template <typename numtype, size_t N>
std::string show(std::array<numtype, N> a, std::string name) {
  std::string output = "\n\n";
  if (name != "") {
    output += name + " (" + std::to_string(N) + ") : \n";
  }
  for (size_t i = 0; i < N; i++) {
    output += std::to_string(a[i]) + "\n";
    if (i > 10) {
      output += "...\n";
      break;
    }
  }
  return output;
}

int main() {

  static constexpr size_t N = 3072;

  // Host data - input and output arrays on the CPU
  std::array<float, N> inputArr;
  std::array<float, N> outputArr;
  for (size_t i = 0; i < N; i++) {
    // Populate input array with a range of dummy values
    inputArr[i] = static_cast<float>(i) / 10.0;
  }

  // API representations for interfacing with the GPU
  WGPUInstance instance; // The instance is the top-level context object for
                         // WebGPU. It is used to create adapters.
  WGPUAdapter adapter;   // The adapter is the physical device that WebGPU uses
                         // to interface with the GPU.
  WGPUDevice device;     // The device is the logical device that WebGPU uses to
                         // interface with the adapter.
  WGPUQueue queue;       // The queue is used to submit work to the GPU.

  // Buffers - buffers are used to store data on the GPU.
  WGPUBuffer inputBuffer;  // The input buffer is used to store the input data.
  WGPUBuffer outputBuffer; // The output buffer is used to store the output data.
  WGPUBuffer readbackBuffer; // The readback buffer is used to copy the output
                             // data from the GPU back to the CPU.
  WGPUCommandBuffer commandBuffer; // The command buffer is used to store the
                                   // sequence of operations to be executed on
                                   // the GPU.

  // Async management - polling the GPU is asynchronous, so we need to manage
  // the async work.
  std::promise<void> promise; // used to signal when the work is done.
  std::future<void> future;   // used to wait for the work to be done.

  // Here we initialize the instance, adapter, device, and queue.
  spdlog::info("Setting up GPU Context");
  {
    const WGPUInstanceDescriptor desc = {};
    WGPURequestAdapterOptions adapterOpts = {};
    WGPUDeviceDescriptor devDescriptor = {};
    spdlog::info("Creating instance");
    {
      instance = wgpuCreateInstance(&desc);
      check(instance, "Initialize WebGPU", __FILE__, __LINE__);
    }
    spdlog::info("Requesting adapter");
    {
      struct AdapterData {
        WGPUAdapter adapter = nullptr;
        bool requestEnded = false;
      };
      AdapterData adapterData;
      WGPURequestAdapterCallbackInfo onAdapterRequestEnded = {
        .nextInChain = NULL,
        .mode        = WGPUCallbackMode_AllowSpontaneous,
        .callback    = [](WGPURequestAdapterStatus status,
                          WGPUAdapterImpl * adapter, WGPUStringView message,
                          void *pUserData0,
                          void *pUserData1
                          ) {
          AdapterData &adapterData = *reinterpret_cast<AdapterData *>(pUserData0);
          check(status == WGPURequestAdapterStatus_Success,
                "Request WebGPU adapter", __FILE__, __LINE__);
          adapterData.adapter = adapter;
          adapterData.requestEnded = true;
        },
        .userdata1   = (void*) &adapterData,
        .userdata2   = NULL
      };
      wgpuInstanceRequestAdapter(instance, &adapterOpts, onAdapterRequestEnded);
      assert(adapterData.requestEnded);
      adapter = adapterData.adapter;
      check(adapter, "Get WebGPU adapter", __FILE__, __LINE__);
    }
    spdlog::info("Requesting device");
    {
      struct DeviceData {
        WGPUDevice device = nullptr;
        bool requestEnded = false;
      };
      DeviceData devData;
      WGPURequestDeviceCallbackInfo onDeviceRequestEnded = {
        .nextInChain = NULL,
        .mode        = WGPUCallbackMode_AllowSpontaneous,
        .callback    = [](WGPURequestDeviceStatus status,
                          WGPUDeviceImpl * device, WGPUStringView message,
                          void *pUserData,
                          void *pUserData2
                          ) {
          DeviceData &devData = *reinterpret_cast<DeviceData *>(pUserData);
          check(status == WGPURequestDeviceStatus_Success,
                "Could not get WebGPU device.", __FILE__, __LINE__);
          spdlog::info("Device Request succeeded {}",
                       static_cast<void *>(device));
          devData.device = device;
          devData.requestEnded = true;
        },
        .userdata1   = (void*) &devData,
        .userdata2   = NULL
      };
      WGPUDeviceLostCallbackInfo callbackInfo = {
        .nextInChain = NULL,
        .mode        = WGPUCallbackMode_AllowSpontaneous,
        .callback = [](WGPUDevice const * device, WGPUDeviceLostReason reason, struct WGPUStringView message, void* userdata1, void* userdata2) {
          spdlog::error("Device lost:\n{}", message.data);
        },
        .userdata1 = NULL,
        .userdata2 = NULL
      };
      WGPUUncapturedErrorCallbackInfo uncapturedErrorCallbackInfo = {
        .nextInChain = NULL,
        .callback = [](WGPUDevice const * device, WGPUErrorType type, struct WGPUStringView message, void* userdata1, void* userdata2) {
          spdlog::error("Device uncaptured error: {}", message.data);
        },
        .userdata1 = NULL,
        .userdata2 = NULL
      };
      devDescriptor.deviceLostCallbackInfo = callbackInfo;
      devDescriptor.uncapturedErrorCallbackInfo = uncapturedErrorCallbackInfo;
      wgpuAdapterRequestDevice(adapter, &devDescriptor, onDeviceRequestEnded);
      assert(devData.requestEnded);
      device = devData.device;
      WGPULoggingCallbackInfo loggingCallbackInfo = {
        .nextInChain = NULL,
        .callback = [](WGPULoggingType type, struct WGPUStringView message, void* userdata1, void* userdata2) {
            spdlog::info("WebGPU Validation: {}", message.data);
        },
        .userdata1 = NULL,
        .userdata2 = NULL
      };
      wgpuDeviceSetLoggingCallback(
          device,
          loggingCallbackInfo);
    }
    // Queue
    spdlog::info("Instantiating device queue");
    queue = wgpuDeviceGetQueue(device);
  }

  // Here we setup the binding group layout. The binding group layout is used to
  // define the layout of the bind group - e.g. how many buffers are going to be
  // used and what their sizes are.
  //
  // The general pattern of using the WebGPU API is to populate a configuration
  // using a descriptor type (*Descriptor), and then pass the descriptor to a
  // factory function (*Create*) operation which returns a handle to the
  // object. Sometimes the descriptors can be hierarchical and nested, but
  // ultimately they are still just an elaborate set of configuration
  // parameters.
  //
  // For example, here we populate a WGPUBindGroupLayoutDescriptor and then
  // pass that to the wgpuDeviceCreateBindGroupLayout() function to get back a
  // WGPUBindGroupLayout.
  spdlog::info("Setting up binding group layout");
  WGPUBindGroupLayout bgLayout;
  static constexpr uint32_t bufferSize =
      static_cast<uint32_t>(sizeof(float) * N);
  spdlog::info("Buffer size: {}, number of elements {}", bufferSize, N);
  {
    WGPUBindGroupLayoutEntry bgLayoutEntries[2];
    bgLayoutEntries[0] = (WGPUBindGroupLayoutEntry){
        .binding = 0,
        .visibility = WGPUShaderStage_Compute,
        .buffer =
            (WGPUBufferBindingLayout){
                .type = WGPUBufferBindingType_Storage,
                .minBindingSize = bufferSize,
            },
    };
    bgLayoutEntries[1] = (WGPUBindGroupLayoutEntry){
        .binding = 1,
        .visibility = WGPUShaderStage_Compute,
        .buffer =
            (WGPUBufferBindingLayout){
                .type = WGPUBufferBindingType_Storage,
                .minBindingSize = bufferSize,
            },
    };
    spdlog::info("Creating Binding Group Layout Description");
    WGPUBindGroupLayoutDescriptor bgLayoutDesc = {
        .entryCount = std::size(bgLayoutEntries),
        .entries = bgLayoutEntries,
    };
    bgLayout = wgpuDeviceCreateBindGroupLayout(device, &bgLayoutDesc);
  }

  // After setting up the binding group layout we initialize the buffers by
  // interacting with the device.
  spdlog::info("Create buffers: input, output, and readback");
  {
    WGPUBufferDescriptor inputBufferDesc = {
        .usage = WGPUBufferUsage_Storage | WGPUBufferUsage_CopyDst,
        .size = bufferSize,
    };
    inputBuffer = wgpuDeviceCreateBuffer(device, &inputBufferDesc);
    WGPUBufferDescriptor outputBufferDesc = {
        .usage = WGPUBufferUsage_Storage | WGPUBufferUsage_CopyDst |
                 WGPUBufferUsage_CopySrc,
        .size = bufferSize,
    };
    outputBuffer = wgpuDeviceCreateBuffer(device, &outputBufferDesc);
    WGPUBufferDescriptor readbackBufferDescriptor = {
        .usage = WGPUBufferUsage_CopyDst | WGPUBufferUsage_MapRead,
        .size = bufferSize,
    };
    readbackBuffer = wgpuDeviceCreateBuffer(device, &readbackBufferDescriptor);
    check(inputBuffer, "Create input buffer", __FILE__, __LINE__);
    check(outputBuffer, "Create output buffer", __FILE__, __LINE__);
    check(readbackBuffer, "Create readback buffer", __FILE__, __LINE__);
  }

  // We create the bind group with references to the buffers and initialize the
  // binding group. Does this seem redundant with the binding group layout?
  // Probably.
  // The bind group is used to bind the buffers to the compute pipeline.
  // The bind group layout is used to define the layout of the bind group.
  spdlog::info("Create the bind group");
  WGPUBindGroup bindGroup;
  {
    WGPUBindGroupEntry bindGroupEntries[2];
    bindGroupEntries[0] = (WGPUBindGroupEntry){
        .binding = 0,
        .buffer = inputBuffer,
        .offset = 0,
        .size = bufferSize,
    };
    bindGroupEntries[1] = (WGPUBindGroupEntry){
        .binding = 1,
        .buffer = outputBuffer,
        .offset = 0,
        .size = bufferSize,
    };
    WGPUBindGroupDescriptor bindGroupDesc = {
        .layout = bgLayout,
        .entryCount = std::size(bindGroupEntries),
        .entries = bindGroupEntries,
    };
    bindGroup = wgpuDeviceCreateBindGroup(device, &bindGroupDesc);
  }

  // We create the compute pipeline with the shader module and pipeline layout.
  // The compute pipeline is used to run the compute shader.
  spdlog::info("Creating the compute pipeline");
  WGPUComputePipeline computePipeline;
  {
    WGPUPipelineLayout pipelineLayout;
    WGPUPipelineLayoutDescriptor pipelineLayoutDesc = {
        .bindGroupLayoutCount = 1,
        .bindGroupLayouts = &bgLayout,
    };
    pipelineLayout =
        wgpuDeviceCreatePipelineLayout(device, &pipelineLayoutDesc);
    WGPUShaderModuleWGSLDescriptor wgslDesc = {
      .chain = {.sType = WGPUSType_ShaderSourceWGSL},
      .code = {
        .data = kShaderGELU,
        .length = strlen(kShaderGELU)
      }
    };
    WGPUShaderModuleDescriptor shaderModuleDesc = {
      .nextInChain = &wgslDesc.chain,
      .label = {
        .data = "shader",
        .length = strlen("shader")
      }
    };
    WGPUComputePipelineDescriptor computePipelineDesc = {
      .layout = pipelineLayout,
      .compute = {
        .module = wgpuDeviceCreateShaderModule(device, &shaderModuleDesc),
        .entryPoint = {
          .data = "main",
          .length = strlen("main")
        }
      }
    };
    computePipeline =
        wgpuDeviceCreateComputePipeline(device, &computePipelineDesc);
    check(computePipeline, "Create compute pipeline", __FILE__, __LINE__);
  }

  // We create the command encoder and the compute pass encoder. The command
  // encoder is used to encode commands for the GPU. The compute pass encoder is
  // used to encode commands for the compute pipeline.
  spdlog::info("Create the command encoder");
  {
    static constexpr uint32_t kWorkgroupSize = 256; // This needs to match the
                                                    // workgroup size in the
                                                    // shader.
    WGPUCommandEncoder commandEncoder;
    WGPUComputePassEncoder computePassEncoder;
    commandEncoder = wgpuDeviceCreateCommandEncoder(device, nullptr);
    computePassEncoder =
        wgpuCommandEncoderBeginComputePass(commandEncoder, nullptr);
    wgpuComputePassEncoderSetPipeline(computePassEncoder, computePipeline);
    wgpuComputePassEncoderSetBindGroup(computePassEncoder, 0, bindGroup, 0,
                                       nullptr);
    wgpuComputePassEncoderDispatchWorkgroups(
        computePassEncoder, (N + (kWorkgroupSize - 1)) / kWorkgroupSize, 1, 1);
    wgpuComputePassEncoderEnd(computePassEncoder);
    wgpuCommandEncoderCopyBufferToBuffer(commandEncoder, outputBuffer, 0,
                                         readbackBuffer, 0, bufferSize);
    commandBuffer = wgpuCommandEncoderFinish(commandEncoder, nullptr);
    check(commandBuffer, "Create command buffer", __FILE__, __LINE__);
  }
  spdlog::info("Initializing promise and future");
  promise = std::promise<void>();
  future = promise.get_future();

  spdlog::info("Copying input data to GPU");
  wgpuQueueWriteBuffer(queue, inputBuffer, 0, inputArr.data(), bufferSize);

  // Submit the command buffer and launch the kernel. The command buffer is
  // submitted to the queue and a callback is set up to handle the completion of
  // the job which updates the promise. A while loop is used to wait for the
  // promise to be set.
  spdlog::info("Submit the command buffer and launching the kernel");
  struct CallbackData {
    WGPUBuffer buffer;
    size_t bufferSize;
    float *output;
    std::promise<void> *promise;
  };
  {

    // Submit the command buffer
    wgpuQueueSubmit(queue, 1, &commandBuffer);
    CallbackData callbackData =
        CallbackData{readbackBuffer, sizeof(outputArr), nullptr, &promise};
    // Set up the callback for when the work is done
    WGPUQueueWorkDoneCallbackInfo callback = {
      .nextInChain = NULL,
      .mode        = WGPUCallbackMode_AllowSpontaneous,
      .callback    = [](WGPUQueueWorkDoneStatus status, void* userdata1, void* userdata2) {
        spdlog::info("QueueOnSubmittedWorkDone status: {}",
                     WGPUQueueWorkDoneStatus_Success == status);
        check(status == WGPUQueueWorkDoneStatus_Success, "Queue work done",
              __FILE__, __LINE__);
        const auto *data = static_cast<CallbackData *>(userdata1);
        data->promise->set_value();
      },
      .userdata1   = (void*) &callbackData,
      .userdata2   = NULL
    };
    wgpuQueueOnSubmittedWorkDone(
        queue,
        callback);
    // Wait for the promise to be set
    while (future.wait_for(std::chrono::seconds(0)) !=
           std::future_status::ready) {
      wgpuInstanceProcessEvents(instance);
    }
  }

  // Copy the output data back to the CPU. This requires its own command encoder
  // and command buffer. As with the computation a job is asynchronously
  // submitted to the queue and a callback is set up to handle the completion
  // of the job which updates the promise.
  //
  // The execution blocks on the future until the promise is set, after which
  // the result of the computation is copied to the outputArr array and is
  // printed.
  spdlog::info("Copying output to the CPU");
  {
    // reset the promise and future
    promise = std::promise<void>();
    future = promise.get_future();
    spdlog::info("Setting up command encoder and command buffer for copying "
                 "output to the CPU");
    {
      WGPUCommandEncoder commandEncoder;
      WGPUComputePassEncoder computePassEncoder;
      commandEncoder = wgpuDeviceCreateCommandEncoder(device, nullptr);
      wgpuCommandEncoderCopyBufferToBuffer(commandEncoder, outputBuffer, 0,
                                           readbackBuffer, 0, bufferSize);
      commandBuffer = wgpuCommandEncoderFinish(commandEncoder, nullptr);
      check(commandBuffer, "Create command buffer", __FILE__, __LINE__);
    }
    wgpuQueueSubmit(queue, 1, &commandBuffer);
    CallbackData callbackData = {readbackBuffer, bufferSize, outputArr.data(),
                                 &promise};
    WGPUQueueWorkDoneCallbackInfo callback = {
      .nextInChain = NULL,
      .mode        = WGPUCallbackMode_AllowSpontaneous,
      .callback    = [](WGPUQueueWorkDoneStatus status, void* userdata1, void* userdata2) {
        spdlog::info("QueueOnSubmittedWorkDone status: {}",
                     WGPUQueueWorkDoneStatus_Success == status);
        check(status == WGPUQueueWorkDoneStatus_Success, "Queue work done",
              __FILE__, __LINE__);
        const auto *data = static_cast<CallbackData *>(userdata1);
        WGPUBufferMapCallbackInfo callback = {
          .nextInChain = NULL,
          .mode        = WGPUCallbackMode_AllowSpontaneous,
          .callback = [](WGPUMapAsyncStatus status, struct WGPUStringView message, void* userdata1, void* userdata2) {
            const auto *data = static_cast<CallbackData *>(userdata1);
            check(status == WGPUMapAsyncStatus_Success,
                  "Map readbackBuffer", __FILE__, __LINE__);
            const void *mappedData = wgpuBufferGetConstMappedRange(
                                                                   data->buffer, /*offset=*/0, data->bufferSize);
            check(mappedData, "Get mapped range", __FILE__, __LINE__);
            memcpy(data->output, mappedData, data->bufferSize);
            wgpuBufferUnmap(data->buffer);
            data->promise->set_value();
          },
          .userdata1 = (void*) data,
          .userdata2 = NULL
        };
        wgpuBufferMapAsync(data->buffer, WGPUMapMode_Read, 0, bufferSize, callback);
      },
      .userdata1   = (void*) &callbackData,
      .userdata2   = NULL
    };
    wgpuQueueOnSubmittedWorkDone(
        queue,
        callback);
    while (future.wait_for(std::chrono::seconds(0)) !=
           std::future_status::ready) {
      wgpuInstanceProcessEvents(instance);
    }
  }

  spdlog::info("{}", show<float, N>(inputArr, "GELU Input"));
  spdlog::info("{}", show<float, N>(outputArr, "GELU Output"));
  spdlog::info("Done with GELU kernel");
}
