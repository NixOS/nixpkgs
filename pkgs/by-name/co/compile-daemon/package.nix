{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "compile-daemon";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "githubnemo";
    repo = "CompileDaemon";
    rev = "v${version}";
    sha256 = "sha256-gpyXy7FO7ZVXJrkzcKHFez4S/dGiijXfZ9eSJtNlm58=";
  };

  vendorHash = "sha256-UpktrXY6OntOA1sxKq3qI59zrOwwCuM+gfGGxPmUJRo=";

  patches = [
    (fetchpatch {
      url = "https://github.com/githubnemo/CompileDaemon/commit/39bc1352dc62fea06dff40c5eaef81ab1bdb1f14.patch";
      hash = "sha256-Zftbw2nu8zzaoj0uwEwdq7xlyycdC0xxBu/qE9VHASI=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Very simple compile daemon for Go";
    homepage = "https://github.com/githubnemo/CompileDaemon";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "CompileDaemon";
  };
}
