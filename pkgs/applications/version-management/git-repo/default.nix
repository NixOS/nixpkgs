{ lib, stdenv, fetchFromGitHub, makeWrapper, nix-update-script
, python3, git, gnupg, less, openssh
}:

stdenv.mkDerivation rec {
  pname = "git-repo";
  version = "2.36";

  src = fetchFromGitHub {
    owner = "android";
    repo = "tools_repo";
    rev = "v${version}";
    hash = "sha256-TCCVdPhrR4NWwqNjEAySSsiW2D7gCdLAiD+UeuvBJvI=";
  };

  # Fix 'NameError: name 'ssl' is not defined'
  patches = [ ./import-ssl-module.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace repo --replace \
      'urllib.request.urlopen(url)' \
      'urllib.request.urlopen(url, context=ssl.create_default_context())'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp repo $out/bin/repo

    runHook postInstall
  '';

  # Important runtime dependencies
  postFixup = ''
    wrapProgram $out/bin/repo --prefix PATH ":" \
      "${lib.makeBinPath [ git gnupg less openssh ]}"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Android's repo management tool";
    longDescription = ''
      Repo is a Python script based on Git that helps manage many Git
      repositories, does the uploads to revision control systems, and automates
      parts of the development workflow. Repo is not meant to replace Git, only
      to make it easier to work with Git.
    '';
    homepage = "https://android.googlesource.com/tools/repo";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    platforms = platforms.unix;
  };
}
