{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,

  cmake,
  curl,
  go,
  unzip,
  zip,

  catch2,
  cxxopts,
  fmt,

  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protonmail-export";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-mail-export";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-rpfTI3vcZlEK1TrxRMMHFKutwC/YqAZrZCFiUsfMafc=";
  };

  goModules =
    (buildGoModule {
      pname = "protonmail-export-go-modules";
      inherit (finalAttrs) src version;
      sourceRoot = "${finalAttrs.src.name}/go-lib";
      vendorHash = "sha256-rKi3PNsYsZA+MLcLTVrVI3T2SUBZCiq9Zxtf+1SGArk=";

      nativeBuildInputs = [ unzip ];

      proxyVendor = true;
    }).goModules;

  postPatch = ''
    echo "" > vcpkg/scripts/buildsystems/vcpkg.cmake

    substituteInPlace CMakeLists.txt \
      --replace-fail 'include(clang_tidy)' ''' \
      --replace-fail 'include(clang_format)' '''

    substituteInPlace lib/CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' '''

    substituteInPlace cli/bin/main.cpp --replace-fail \
      'execPath = etcpp::getExecutableDir();' 'execPath = std::filesystem::u8path(std::getenv("HOME")) / ".config" / "protonmail-export";'
  '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://$goModules
  '';

  nativeBuildInputs = [
    cmake
    curl
    go
    unzip
    zip
  ];

  buildInputs = [
    fmt
    catch2
    cxxopts
  ];

  postInstall =
    let
      so = "proton-mail-export${stdenv.hostPlatform.extensions.library}";
    in
    ''
      install -Dm644 $out/bin/${so} -t $out/lib
      rm -f $out/bin/${so}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -change @loader_path/${so} \
        $out/lib/${so} \
        $out/bin/proton-mail-export-cli
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/proton-mail-export-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Export your Proton Mail emails as eml files";
    homepage = "https://github.com/ProtonMail/proton-mail-export";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "proton-mail-export-cli";
  };
})
