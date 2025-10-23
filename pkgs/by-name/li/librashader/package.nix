{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librashader";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "SnowflakePowered";
    repo = "librashader";
    tag = "librashader-v${finalAttrs.version}";
    hash = "sha256-jrx7TzV9Q7JB8se6J5Wfa1iT1RSJnZbjEn7yTZ64zYU=";
  };

  patches = [
    ./patches/fix-optional-dep-syntax.patch
  ];

  cargoHash = "sha256-LFub48GklgOLncqazAIn2Bz+tSsXgS4TTnAdfYw7xHk=";

  buildPhase = ''
    runHook preBuild
    cargo run -p librashader-build-script -- --profile optimized --stable
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    cd target/optimized
    mkdir -p $out/lib $out/include/librashader
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        install_name_tool -id $out/lib/librashader.dylib librashader.dylib
        install -m755 librashader.dylib $out/lib/librashader.dylib
      ''
    else
      ''
        patchelf --set-soname librashader.so.2 librashader.so
        install -m755 librashader.so $out/lib/librashader.so.2
        ln -s $out/lib/librashader.so.2 $out/lib/librashader.so
      ''
  )
  + ''
    install -m644 ../../include/librashader.h -t $out/include/librashader
    install -m644 ../../include/librashader_ld.h -t $out/include/librashader
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "librashader-v(.*)"
    ];
  };

  meta = {
    description = "RetroArch Shaders for All";
    homepage = "https://github.com/SnowflakePowered/librashader";
    license = with lib.licenses; [
      mpl20
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ nadiaholmquist ];
    platforms = lib.platforms.all;
  };
})
