{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles
, makeWrapper
, enableCmount ? true, fuse, macfuse-stubs
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0pwbprbkx5y0c93b61k8znan4aimk7dkssapjhkhzw4c38xd4lza";
  };

  vendorSha256 = "0353pff07lwpa1jmi095kb2izcw09z73x6nninnnpyqppwzas6ha";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  buildInputs = lib.optional enableCmount (if stdenv.isDarwin then macfuse-stubs else fuse);
  nativeBuildInputs = [ installShellFiles makeWrapper ];

  tags = lib.optionals enableCmount [ "cmount" ];

  ldflags = [ "-s" "-w" "-X github.com/rclone/rclone/fs.Version=${version}" ];

  postInstall =
    let
      rcloneBin =
        if stdenv.buildPlatform == stdenv.hostPlatform
        then "$out"
        else lib.getBin buildPackages.rclone;
    in
    ''
      installManPage rclone.1
      for shell in bash zsh fish; do
        ${rcloneBin}/bin/rclone genautocomplete $shell rclone.$shell
        installShellCompletion rclone.$shell
      done
    '' + lib.optionalString (enableCmount && !stdenv.isDarwin) ''
      wrapProgram $out/bin/rclone --prefix LD_LIBRARY_PATH : "${fuse}/lib"
    '';

  meta = with lib; {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "https://rclone.org";
    changelog = "https://github.com/rclone/rclone/blob/v${version}/docs/content/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ danielfullmer marsam SuperSandro2000 ];
  };
}
