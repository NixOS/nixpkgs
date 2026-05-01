{
  lib,
  fetchFromGitHub,
  rustPlatform,
  tzdata,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    tag = "v${version}";
    hash = "sha256-1CAUl9NB1QjduXgwOIcMclXA6SpaTP+kd3j25BK5Q/8=";
  };

  cargoHash = "sha256-EBfhi7puB2To/1GLbXW6Tz1zazDswvh+NqqBkeqRtAI=";

  env.NUMBAT_SYSTEM_MODULE_PATH = "${placeholder "out"}/share/numbat/modules";

  postInstall = ''
    mkdir -p $out/share/numbat
    cp -r $src/numbat/modules $out/share/numbat/

    mkdir -p $out/share/applications
    cp $src/assets/numbat.desktop $out/share/applications

    for size in 16 22 24 32 48 64 128 256 512; do
      dims="''${size}x''${size}"
      dest=$out/share/icons/hicolor/''${dims}/apps
      mkdir -p $dest
      cp $src/assets/numbat-''${dims}.png ''${dest}/numbat.png
    done

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $src/assets/numbat.svg $out/share/icons/hicolor/scalable/apps
  '';

  preCheck = ''
    # The datetime library used by Numbat, "jiff", always attempts to use the
    # system TZDIR on Unix and doesn't fall back to the embedded tzdb when not
    # present.
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High precision scientific calculator with full support for physical units";
    longDescription = ''
      A statically typed programming language for scientific computations
      with first class support for physical dimensions and units
    '';
    homepage = "https://numbat.dev";
    changelog = "https://github.com/sharkdp/numbat/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      giomf
      atemu
    ];
    mainProgram = "numbat";
  };
}
