#include <ouster/core/sensor_info.h>
#include <ouster/osf/writer.h>

int main(int argc, char** argv) {
    if (argc != 2) return 2;
    auto info = ouster::sdk::core::SensorInfo::from_default(
        ouster::sdk::core::LidarMode::_1024x10);
    ouster::sdk::osf::Writer writer(argv[1], *info);
    writer.close();
    return info->format.columns_per_frame == 1024 ? 0 : 1;
}
