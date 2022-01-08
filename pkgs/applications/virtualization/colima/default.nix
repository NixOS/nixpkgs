{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lima
, makeWrapper
}:

buildGoModule rec {
  pname = "colima";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vWNkYsT2XF+oMOQ3pb1+/a207js8B+EmVanRQrYE/2A=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-F1ym88JrJWzsBg89Y1ufH4oefIRBwTGOw72BrjtpvBw=";

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${lib.makeBinPath [ lima ]}

    installShellCompletion --cmd colima \
      --bash <($out/bin/colima completion bash) \
      --fish <($out/bin/colima completion fish) \
      --zsh <($out/bin/colima completion zsh)
  '';

  meta = with lib; {
    description = "Container runtimes on MacOS with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ aaschmid ];
  };
}
