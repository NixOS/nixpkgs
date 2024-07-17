{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  darwin,
  libX11,
  libXt,
  libGL,
  openimageio,
  imath,
  python3Packages,
  python3,
}:

python3Packages.buildPythonPackage rec {
  pname = "materialx";
  version = "1.38.10";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    rev = "v${version}";
    sha256 = "sha256-/kMHmW2dptZNtjuhE5s+jvPRIdtY+FRiVtMU+tiBgQo=";
  };

  format = "other";

  nativeBuildInputs = [
    cmake
    python3Packages.setuptools
  ];

  buildInputs =
    [
      openimageio
      imath
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        OpenGL
        Cocoa
      ]
    )
    ++ lib.optionals (!stdenv.isDarwin) [
      libX11
      libXt
      libGL
    ];

  cmakeFlags = [
    (lib.cmakeBool "MATERIALX_BUILD_OIIO" true)
    (lib.cmakeBool "MATERIALX_BUILD_PYTHON" true)
    # don't build MSL shader back-end on x86_x64-darwin, as it requires a newer SDK with metal support
    (lib.cmakeBool "MATERIALX_BUILD_GEN_MSL" (stdenv.isLinux || (stdenv.isAarch64 && stdenv.isDarwin)))
  ];

  pythonImportsCheck = [ "MaterialX" ];

  postInstall = ''
    # Make python lib properly accessible
    target_dir=$out/${python3.sitePackages}
    mkdir -p $(dirname $target_dir)
    # required for cmake to find the bindings, when included in other projects
    ln -s $out/python $target_dir
  '';

  meta = {
    description = "Open standard for representing rich material and look-development content in computer graphics";
    homepage = "https://materialx.org";
    maintainers = [ lib.maintainers.gador ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
  };
}
