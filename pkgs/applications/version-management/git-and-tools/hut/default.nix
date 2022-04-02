{ lib
, buildGoModule
, fetchFromSourcehut
, scdoc
, unstableGitUpdater
}:

buildGoModule {
  pname = "hut";
  version = "unstable-2022-03-02";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "55ad2fbd9ceeeb9e7dc203c15476fa785f1209e0";
    sha256 = "sha256-j2IVwCm7iq3JKccPL8noRBhqw+V+4qfcpAwV65xhZk0=";
  };

  vendorSha256 = "sha256-zdQvk0M1a+Y90pnhqIpKxLJnlVJqMoSycewTep2Oux4=";

  nativeBuildInputs = [
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postBuild = ''
    make $makeFlags completions doc/hut.1
  '';

  preInstall = ''
    make $makeFlags install
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://sr.ht/~emersion/hut/";
    description = "A CLI tool for Sourcehut / sr.ht";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
