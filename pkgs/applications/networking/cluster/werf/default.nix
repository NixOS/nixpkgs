{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkg-config
, gpgme
, glibc
, lvm2
, btrfs-progs
}:

buildGoModule rec {
  pname = "werf";
  version = "1.2.99";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
    sha256 = "sha256-D9NwVZGB0UV0tRe927GpxHzdvAeqcRJOYfocbbj6BRM=";
  };
  vendorSha256 = "sha256-ZMSTl9WFTF5x+tiQZ37ihVrOuLS0W5PjyXbbzyHJNsI=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ gpgme ]
    ++ lib.optionals stdenv.isLinux [ glibc.static lvm2 btrfs-progs ];

  # Flags are derived from
  # https://github.com/werf/werf/blob/main/scripts/build_release_v3.sh
  ldflags = [ "-s" "-w" "-X github.com/werf/werf/pkg/werf.Version=v${version}" ]
    ++ lib.optionals stdenv.isLinux [
    "-linkmode external"
    "-extldflags=-static"
  ];
  tags = [ "dfrunmount" "dfssh" "containers_image_openpgp" ]
    ++ lib.optionals stdenv.isLinux [
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  subPackages = [ "cmd/werf" ];

  postInstall = ''
    installShellCompletion --cmd werf \
      --bash <($out/bin/werf completion --shell=bash) \
      --zsh <($out/bin/werf completion --shell=zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/werf/werf";
    description = "GitOps delivery tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
