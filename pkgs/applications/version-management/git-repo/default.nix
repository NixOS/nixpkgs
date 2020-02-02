{ stdenv, fetchFromGitHub, makeWrapper
, python, git, gnupg, less, cacert
}:

stdenv.mkDerivation rec {
  pname = "git-repo";
  version = "1.13.8";

  src = fetchFromGitHub {
    owner = "android";
    repo = "tools_repo";
    rev = "v${version}";
    sha256 = "1wmzgijmssgwkkw8g4zgmc4x64xkvz6nq1b3szcvawgv1ndwnb2j";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python ];

  patchPhase = ''
    substituteInPlace repo --replace \
      'urllib.request.urlopen(url)' \
      'urllib.request.urlopen(url, cafile="${cacert}/etc/ssl/certs/ca-bundle.crt")'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp repo $out/bin/repo
  '';

  # Important runtime dependencies
  postFixup = ''
    wrapProgram $out/bin/repo --prefix PATH ":" \
      "${stdenv.lib.makeBinPath [ git gnupg less ]}"
  '';

  meta = with stdenv.lib; {
    description = "Android's repo management tool";
    longDescription = ''
      Repo is a Python script based on Git that helps manage many Git
      repositories, does the uploads to revision control systems, and automates
      parts of the development workflow. Repo is not meant to replace Git, only
      to make it easier to work with Git.
    '';
    homepage = https://android.googlesource.com/tools/repo;
    license = licenses.asl20;
    maintainers = [ maintainers.primeos ];
    platforms = platforms.unix;
  };
}
