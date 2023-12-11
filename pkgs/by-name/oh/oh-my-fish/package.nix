{ lib
, stdenv
, fetchFromGitHub
, fish
, runtimeShell
, substituteAll
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-fish";
  version = "unstable-2022-03-27";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "oh-my-fish";
    rev = "d428b723c8c18fef3b2a00b8b8b731177f483ad8";
    hash = "sha256-msItKEPe7uSUpDAfCfdYZjt5NyfM3KtOrLUTO9NGqlg=";
  };

  patches = [
    ./001-writable-omf-path.diff
  ];

  buildInputs = [
    fish
  ];

  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin $out/share/oh-my-fish
    cp -vr * $out/share/oh-my-fish

    cp -v ${substituteAll {
      name = "omf-install";
      src = ./omf-install;
      OMF = placeholder "out";
      inherit fish runtimeShell;
    }} $out/bin/omf-install

    chmod +x $out/bin/omf-install
    cat $out/bin/omf-install

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/oh-my-fish/oh-my-fish";
    description = "The Fish Shell Framework";
    longDescription = ''
      Oh My Fish provides core infrastructure to allow you to install packages
      which extend or modify the look of your shell. It's fast, extensible and
      easy to use.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "omf-install";
    inherit (fish.meta) platforms;
  };
})
# TODO: customize the omf-install script
