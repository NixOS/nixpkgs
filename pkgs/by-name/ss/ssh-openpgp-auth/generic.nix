# This file is based upon upstream's package.nix shared among both
# "ssh-openpgp-auth" and "sshd-openpgpg-auth"
{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, just
, rust-script
, installShellFiles
, nettle
, openssl
, sqlite
, stdenv
, darwin
, openssh
# Arguments not supplied by callPackage
, pname , version , srcHash , cargoHash, metaDescription
}:

rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wiktor";
    repo = "ssh-openpgp-auth";
    # See also: https://codeberg.org/wiktor/ssh-openpgp-auth/pulls/92#issuecomment-1635274
    rev = "${pname}/${version}";
    hash = srcHash;
  };
  buildAndTestSubdir = pname;
  inherit cargoHash;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    just
    rust-script
    installShellFiles
  ];
  # Otherwise just's build, check and install phases take precedence over
  # buildRustPackage's phases.
  dontUseJustBuild = true;
  dontUseJustCheck = true;
  dontUseJustInstall = true;

  postInstall = ''
    export HOME=$(mktemp -d)
    just generate manpages ${pname} $out/share/man/man1
    just generate shell_completions ${pname} shell_completions
    installShellCompletion --cmd ${pname} \
      --bash shell_completions/${pname}.bash \
      --fish shell_completions/${pname}.fish \
      --zsh  shell_completions/_${pname}
  '';


  buildInputs = [
    nettle
    openssl
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.IOKit
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.frameworks.SystemConfiguration
  ];

  doCheck = true;
  nativeCheckInputs = [
    openssh
  ];

  meta = with lib; {
    description = metaDescription;
    homepage = "https://codeberg.org/wiktor/ssh-openpgp-auth";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = pname;
  };
}
