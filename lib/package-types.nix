{ lib }:
# Types of packages
# Based on the CycloneDX component type - https://cyclonedx.org/docs/1.7/json/#components_items_type
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
