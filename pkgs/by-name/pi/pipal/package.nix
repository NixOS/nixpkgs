{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  runtimeShell,
  gitUpdater,
  versionCheckHook,
}:
let
  rubyEnv = ruby.withPackages (ps: with ps; [ levenshtein-ffi ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pipal";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "digininja";
    repo = "pipal";
    tag = finalAttrs.version;
    hash = "sha256-t513Mn+62hN1K5r6Ppe2kA46YUHGYqyY5/SCRNn/8I0="; # fix with real hash
  };

  buildInputs = [
    rubyEnv
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pipal}

    install -dm 755 "$out/bin"
    install -dm 755 "$out/share/pipal"

    cp -a * "$out/share/pipal/"
    cat > $out/bin/pipal <<EOF
    #!${runtimeShell} -eu
    exec ${rubyEnv}/bin/ruby "$out/share/pipal/pipal.rb" "\$@"
    EOF
    chmod +x $out/bin/pipal

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Password analyser that identify security weaknesses";
    homepage = "https://digi.ninja/projects/pipal.php";
    platforms = lib.platforms.linux;
    license = lib.licenses.cc-by-nc-sa-20;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "pipal";
  };
})
