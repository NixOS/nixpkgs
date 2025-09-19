# nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
{
  lib,
  python3Packages,
  python3,
  fetchFromGitHub,
  makeWrapper,
}:
# https://nixos.org/manual/nixpkgs/stable/#buildpythonpackage-function
python3Packages.buildPythonApplication rec {
  pname = "discord-rich-presence-plex";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "phin05";
    repo = "discord-rich-presence-plex";
    tag = "v${version}";
    hash = "sha256-e1r0w72IOEY5XsjANkAHbfPYEf1B8n6KYVLMWFSLs0g=";
  };

  dependencies = with python3Packages; [
    plexapi
    requests
    websocket-client
    pyyaml
    pillow
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # because this project does not use setup-tools
  dontBuild = true;
  format = "other";
  dontUseSetuptoolsBuild = true;
  dontUseSetuptoolsCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/discord-rich-presence-plex
    cp -r * $out/lib/discord-rich-presence-plex/

    mkdir -p $out/bin
    makeWrapper \
    ${python3}/bin/python \
    $out/bin/discord-rich-presence-plex \
    --add-flags "$out/lib/discord-rich-presence-plex/main.py" \
    --prefix PYTHONPATH : "$out/lib/discord-rich-presence-plex:$PYTHONPATH" \
    --set DRPP_NO_PIP_INSTALL "true"
    runHook postInstall
  '';

  #    patchPhase = ''
  #      substituteInPlace app/constants.py \
  #        --replace 'dataDirectoryPath = "data"'\
  #        'dataDirectoryPath = os.path.join(os.environ.get("XDG_DATA_HOME", "discord-rich-presence-plex")); print("DEBUG: dataDirectoryPath ="+ dataDirectoryPath)'
  #      '';
  # DRPP_NO_PIP_INSTALL is an application specific variable, removes call to pip in script
  doCheck = false; # disable dependency injection for tests as we are not testing.
  meta = {
    homepage = "https://github.com/phin05/discord-rich-presence-plex";
    license = lib.licenses.gpl3Only;
    description = "Displays your Plex status on Discord using Rich Presence";
    maintainers = with lib.maintainers; [ hogcycle ];
  };
}
