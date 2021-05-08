{ lib, stdenv, buildGoModule, fetchFromGitHub, buildPackages, installShellFiles
, makeWrapper
, enableCmount ? true, fuse, macfuse-stubs
}:

buildGoModule rec {
  pname = "rclone";
  version = "1.55.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1fyi12qz2igcf9rqsp9gmcgfnmgy4g04s2b03b95ml6klbf73cns";
  };

  vendorSha256 = "199z3j62xw9h8yviyv4jfls29y2ri9511hcyp5ix8ahgk6ypz8vw";

  subPackages = [ "." ];

  outputs = [ "out" "man" ];

  buildInputs = lib.optional enableCmount (if stdenv.isDarwin then macfuse-stubs else fuse);
  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildFlagsArray = lib.optionals enableCmount [ "-tags=cmount" ]
    ++ [ "-ldflags=-s -w -X github.com/rclone/rclone/fs.Version=${version}" ];

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
