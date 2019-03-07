{ buildGoPackage, src }:
# A specialized buildGoPackage for the terraform provider plugins
{ pname, version, ... }@attrs:
buildGoPackage ({
  name = "${pname}-${version}";

  # Only build the provider
  subPackages = [ "." ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/${pname}{,_v${version}}";
} // attrs)
