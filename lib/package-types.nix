{ lib }:
# Types of packages
# Based on the CycloneDX component type - https://cyclonedx.org/docs/1.7/json/#components_items_type
# & the SPDX Software Purpose vocab - https://spdx.github.io/spdx-spec/v3.0.1/model/Software/Vocabularies/SoftwarePurpose/
lib.genAttrs [
  "application"
  "framework"
  "library"
  "container"
  "runtime"
  "operating-system"
  "device-driver"
  "firmware"
  "file"
  "data"
] lib.id
