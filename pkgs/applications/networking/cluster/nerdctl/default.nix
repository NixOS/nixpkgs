{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, buildkit
, cni-plugins
, extraPackages ? []
}:

let
  binPath = lib.makeBinPath ([
    buildkit
  ] ++ extraPackages);
in
buildGoModule rec {
  pname = "nerdctl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vjcbvd5yrasw97hd5mrn6cdjvfv2r03z7g1wczlszlcs8gr6nxw";
  };

  vendorSha256 = "181lp9l4i0qpiqm8wbxa4ldi1j5bm3ygmanz1xh3mkjanl0pwqjr";

  nativeBuildInputs = [ makeWrapper ];

  buildFlagsArray = [
    "-ldflags="
    "-w"
    "-s"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Version=v${version}"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Revision=<unknown>"
  ];

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${binPath}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"
  '';

  meta = with lib; {
    description = "A Docker-compatible CLI for containerd";
    homepage = src.meta.homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jk ];
  };
}
