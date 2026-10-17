{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  eigen,
  fmt,
  nlohmann_json,
  valijson,
  boost,
}:

let
  # Header-only dependencies fetched via CPM.cmake at cmake configure time.
  # When updating this package, verify and update the GIT_TAG commit hashes
  # from cmake/dependencies.cmake.

  if97_src = fetchFromGitHub {
    owner = "CoolProp";
    repo = "IF97";
    rev = "7aaced024a702f0985474bf293cdaae9c8d06521";
    hash = "sha256-qYH4Y39A4GRX1MRCDiO3Hhj36V3jgYQq5uDCCnVe5DM=";
  };

  refprop_headers_src = fetchFromGitHub {
    owner = "CoolProp";
    repo = "REFPROP-headers";
    rev = "b4faab1b73911c32c4b69c526c7e92f74edb67de";
    hash = "sha256-mfGglyfF7NjkpsWSMwqYWSSH+d6PH9ey7MasLznARQA=";
  };

  multicomplex_src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "multicomplex";
    rev = "39bf9ca52c7882ff0788bb9087c7548ebd8fba4c";
    hash = "sha256-iFcOl3BPZarRGE/rd5mC7KAFrX2ooOAvx5z/efBSg/8=";
  };

  msgpack_c_src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "919908742b4fdbc575e77fe1a8657e70c9573c44";
    hash = "sha256-kg4mpNiigfZ59ZeL8LXEHwtkLU8Po+vgRcUcgTJd+h4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "coolprop";
  version = "8.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CoolProp";
    repo = "CoolProp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ESRHzA+Jwa6KAkCSSi3G/U7g1vVBEDPyrmHrYPYvzuk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    eigen
    fmt
    nlohmann_json
    valijson
    boost
  ];

  cmakeFlags = [
    "-DCOOLPROP_SHARED_LIBRARY=ON"
    "-DCOOLPROP_INSTALL_PREFIX=${placeholder "out"}"
    "-DFORCE_BITNESS_NATIVE=ON"
    "-DCPM_Eigen_SOURCE=${eigen.src}"
    "-DCPM_msgpack-c_SOURCE=${msgpack_c_src}"
    "-DCPM_nlohmann_json_SOURCE=${nlohmann_json}"
    "-DCPM_valijson_SOURCE=${valijson}"
    "-DCPM_fmt_SOURCE=${fmt.dev}"
    "-DCPM_boost_headers_SOURCE=${boost.dev}/include"
    "-DCPM_IF97_SOURCE=${if97_src}"
    "-DCPM_REFPROP_headers_SOURCE=${refprop_headers_src}"
    "-DCPM_multicomplex_SOURCE=${multicomplex_src}"
  ];

  postInstall = ''
        mkdir -p $out/lib $out/include $out/lib/pkgconfig

        if [ -d $out/shared_library ]; then
          find $out/shared_library -name "*.so*" -exec cp -a {} $out/lib/ \;
          if [ -d $out/shared_library/include ]; then
            cp -r $out/shared_library/include/* $out/include/
          fi
          rm -rf $out/shared_library
        fi

        if [ -d $out/static_library ]; then
          find $out/static_library -name "*.a" -exec cp -a {} $out/lib/ \;
          if [ -d $out/static_library/include ]; then
            cp -r $out/static_library/include/* $out/include/
          fi
          rm -rf $out/static_library
        fi

        cat <<EOF > $out/lib/pkgconfig/coolprop.pc
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include

    Name: CoolProp
    Description: Thermophysical property database and code for fluids
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lCoolProp
    Cflags: -I\''${includedir}
    EOF
  '';

  meta = {
    description = "Thermophysical property database and code for fluids";
    homepage = "http://www.coolprop.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.all;
  };
})
