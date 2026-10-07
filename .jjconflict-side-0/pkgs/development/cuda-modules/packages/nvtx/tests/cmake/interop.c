/* Declare the C API without the header implementation so the calls resolve to libnvtx3interop. */
#define NVTX_NO_IMPL
#include <nvtx3/nvToolsExt.h>

int main(void)
{
    nvtxRangePushA("interop");
    nvtxRangePop();
    return 0;
}
