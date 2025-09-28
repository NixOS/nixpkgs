{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  bats,
}:

let
  version = "0.6.0";
in
stdenvNoCC.mkDerivation {
  pname = "bash-preexec";
  inherit version;

  src = fetchFromGitHub {
    owner = "rcaloras";
    repo = "bash-preexec";
    tag = version;
    hash = "sha256-4DzbeIiUX7iXy2CeSvRC2X+XnjVk+/UiMbM/dLHx7zU=";
  };

  nativeCheckInputs = [ bats ];

  dontConfigure = true;
  doCheck = true;
  dontBuild = true;

  patchPhase = ''
    runHook prePatch

    # Needed since the tests expect that HISTCONTROL is set.
    sed -i '/setup()/a HISTCONTROL=""' test/bash-preexec.bats

    # Skip tests failing with Bats 1.5.0.
    # See https://github.com/rcaloras/bash-preexec/issues/121
    sed -i '/^@test.*IFS/,/^}/d' test/bash-preexec.bats

    runHook postPatch
  '';

  checkPhase = ''
    runHook preCheck
    bats test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bash-preexec.sh $out/share/bash/bash-preexec.sh
    runHook postInstall
  '';

  meta = {
    description = "Preexec and precmd functions for Bash just like Zsh";
    license = lib.licenses.mit;
    homepage = "https://github.com/rcaloras/bash-preexec";
    changelog = "https://github.com/rcaloras/bash-preexec/releases/tag/${version}";
    maintainers = with lib.maintainers; [
      hawkw
      rycee
    ];
    platforms = lib.platforms.unix;
  };
}
