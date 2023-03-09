{ stdenv
, lib
, fetchgit
, meson
, ninja
, rustc
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hydrasect";
  version = "unstable-2022-05-30";

  src = fetchgit {
    url = "https://git.qyliss.net/hydrasect.git";
    rev = "e8ac7c351122f1a8fc3dbf0cd4805cf2e83d14da";
    hash = "sha256-A1FJGaFGm4Dw28gscOa5fY8Zumjg/0lUe0wul7bmpmw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    rustc
  ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Bisect nix builds";
    homepage = "https://git.qyliss.net/hydrasect/about/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ];
  };
}
