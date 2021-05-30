{ lib, stdenv, fetchFromGitHub, makeWrapper, nix-update-script
, python3, git, gnupg, less
}:

stdenv.mkDerivation rec {
  pname = "git-repo";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "android";
    repo = "tools_repo";
    rev = "v${version}";
    sha256 = "sha256-3FSkWpHda1jVhy/633B+ippWcbKd83IlQcJYS9Qx5wQ=";
  };

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
      "${lib.makeBinPath [ git gnupg less ]}"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "gitRepo";
    };
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
