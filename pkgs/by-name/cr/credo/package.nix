{
  lib,
  fetchFromGitHub,
  beamPackages,
  nix-update-script,
  versionCheckHook,
}:

beamPackages.mixRelease rec {
  pname = "credo";
  version = "1.7.15";

  src = fetchFromGitHub {
    owner = "rrrene";
    repo = "credo";
    rev = "v${version}";
    hash = "sha256-xAMWqX7ehmge+U7628kz9IFLCsJzfJr5C/Qf0DUwqOE=";
  };

  escriptBinName = "credo";

  stripDebug = true;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    inherit (beamPackages) elixir;
    hash = "sha256-N7Rn9tmdTb9CAUWMNAyiQHz4quodHBy0sKu/dy1Thu8=";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/rrrene/credo/";
    description = "Static code analysis tool for the Elixir language with a focus on code consistency and teaching";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "credo";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
}
