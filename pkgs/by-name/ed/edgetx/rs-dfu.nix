{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  edgetx,
}:

# This isn't really exposed in the package scope but is just a transitive dependency
# of edgetx which uses it as a library.
rustPlatform.buildRustPackage rec {
  pname = "rs-dfu";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "EdgeTX";
    repo = "rs-dfu";
    tag = "v${version}";
    hash = "sha256-9PybXRRgqDf0u8o34IWZRuWWTsjPuZr1Sq8aPD/kxng=";
  };

  cargoBuildFlags = [ "--all" ];

  cargoHash = "sha256-gPNrso7OPt553u2S1k9rwhlwa/tu55AncU4MyqOEhP8=";

  # https://github.com/EdgeTX/rs-dfu/blob/main/package.sh
  postInstall = ''
    mkdir -p $out/{cmake,lib,include}
    cp ./cmake/rs_dfu-config.cmake $out/cmake/
    cp ./target/${stdenv.hostPlatform.config}/release/librs_dfu.a $out/lib
    cp ./target/${stdenv.hostPlatform.config}/cxxbridge/rs-dfu/src/lib.rs.h $out/include/rs_dfu.h
  '';

  meta = {
    description = "USB Device Firmware Upgrade (DFU) implementation based on nusb crate";
    homepage = "https://github.com/EdgeTX/rs-dfu";
    license = lib.licenses.mit;
    maintainers = edgetx.meta.maintainers;
  };
}
