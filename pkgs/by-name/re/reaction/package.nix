{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitLab,
}:
let
  version = "1.3.1";
in buildGoModule {
  inherit version;
  pname = "reaction";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    rev = "v${version}";
    sha256 = "sha256-hBEtXaTpubb5sKSrA8bhw3MW6YLszuESWrFZYf/+RvM=";
  };

  vendorHash = "sha256-THUIoWFzkqaTofwH4clBgsmtUlLS9WIB2xjqW7vkhpg=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=unknown"
  ];

  postBuild = ''
    gcc helpers_c/ip46tables.c -o ip46tables
    gcc helpers_c/nft46.c -o nft46
  '';

  postInstall = ''
    cp ip46tables nft46 $out/bin
  '';

  meta = with lib; {
    description = "Scan logs and take action: an alternative to fail2ban";
    homepage = "https://framagit.org/ppom/reaction";
    changelog = "https://framagit.org/ppom/reaction/-/releases/v${version}";
    license = licenses.agpl3Plus;
    mainProgram = "reaction";
    maintainers = with maintainers; [ppom];
    platforms = platforms.unix;
  };
}
