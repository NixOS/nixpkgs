{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b1sgwax67pazcs1lly3h3bb7ww91lcd3nr0w3r3f46d1c6iy8mn";
  };

  vendorSha256 = "0dn6nryf3vn7r0xna02va4wbgkq0z6x8sj6g2mskfywrk0mfhadv";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
