// Links against csmapi and exercises a few classes, including ones that are
// easy to drop from a hand-written source list (the correlation functions).
#include <cmath>
#include <cstdio>

#include <csm/DampedCosineCorrelationFunction.h>
#include <csm/Ellipsoid.h>
#include <csm/Plugin.h>
#include <csm/Version.h>

#define CHECK(cond)                                   \
  do {                                                \
    if (!(cond)) {                                    \
      std::fprintf(stderr, "FAIL: %s\n", #cond);      \
      return 1;                                       \
    }                                                 \
  } while (0)

int main() {
  csm::Version version = CURRENT_CSM_VERSION;
  std::printf("CSM API %s\n", version.version().c_str());
  CHECK(version.major() == 3);

  // No plugins are loaded into a bare program.
  CHECK(csm::Plugin::getList().empty());

  // Default ellipsoid is WGS 84; a point 100 m above the equator.
  csm::Ellipsoid wgs84;
  CHECK(wgs84.getSemiMajorRadius() == CSM_WGS84_SEMI_MAJOR_AXIS);
  double height = wgs84.calculateHeight(csm::EcefCoord(CSM_WGS84_SEMI_MAJOR_AXIS + 100.0, 0.0, 0.0));
  std::printf("height: %.4f\n", height);
  CHECK(std::fabs(height - 100.0) < 1e-3);

  // A * exp(-dt/T) * cos(2*pi*dt/P) with A = 1, T = 10, P = 5.
  csm::DampedCosineCorrelationFunction corr(1.0, 10.0, 5.0);
  CHECK(corr.getCorrelationCoefficient(0.0) == 1.0);
  CHECK(std::fabs(corr.getCorrelationCoefficient(5.0) - std::exp(-0.5)) < 1e-12);

  std::puts("ok");
  return 0;
}
