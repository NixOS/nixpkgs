{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "git-vanity-hash";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "git-vanity-hash";
    # v1.0.0 + build fix
    rev = "a80e7725ac6d0b7e6807cd7315cfdc7eaf0584f6";
    hash = "sha256-1z4jbtzUB3SH79dDXAITf7Vup1YZdTLHBieSrhrvSXc=";
  };

  cargoHash = "sha256-+SQ0HpURBjnnwH1Ue7IUReOtI4LxVPK9AGSAihs0qsc=";

  postInstall = ''
    mkdir -p $out/share/doc/git-vanity-hash
    cp README.md $out/share/doc/git-vanity-hash
  '';

  meta = with lib; {
    homepage = "https://github.com/prasmussen/git-vanity-hash";
    description = "Tool for creating commit hashes with a specific prefix";
    license = [ licenses.mit ];
    maintainers = [ maintainers.kaction ];
    mainProgram = "git-vanity-hash";
  };
}
