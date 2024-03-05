{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  curl,
  feh,
  file,
  jq,
  util-linux,
  wget,
}:
stdenvNoCC.mkDerivation rec {
  pname = "stylish";
  version = "unstable-2022-12-05";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "thevinter";
    repo = "styli.sh";
    rev = "d595412a949c6cdc7e151ae0cf929aa1958aa7f1";
    hash = "sha256-lFnzrYnTFWe8bvK//aC1+TapWIFNsNP60Msn7D0tk/0=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp "${src}/styli.sh" $out/bin
    chmod +x $out/bin/styli.sh
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/styli.sh --prefix PATH : ${lib.makeBinPath [
      curl
      feh
      file
      jq
      util-linux
      wget
    ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/thevinter/styli.sh";
    description = "A shell script to manage wallpapers";
    longDescription = ''
      Styli.sh is a Bash script that aims to automate the tedious process
      of finding new wallpapers, downloading and switching them via the
      configs.
      Styli.sh can search for specific wallpapers from unsplash or download
      a random image from the specified subreddits. If you have pywal it also
      can set automatically your terminal colors.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ tchab ];
  };
}
