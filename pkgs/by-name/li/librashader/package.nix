{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librashader";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "SnowflakePowered";
    repo = "librashader";
    tag = "librashader-v${finalAttrs.version}";
    hash = "sha256-S0EZES4KLL52UT6ub9GVGl/n2gWxmoxazwZr7oEMTHo=";
  };

  patches = [
    ./patches/fix-optional-dep-syntax.patch
  ];

  cargoHash = "sha256-fKYpRvH8zt7GeiaBf1oZHBY4WSCVQzZ0Ca7Q3ek6QE0=";

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
