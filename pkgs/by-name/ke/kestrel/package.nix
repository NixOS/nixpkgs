{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "kestrel";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "finfet";
    repo = "kestrel";
    rev = "v${version}";
    hash = "sha256-bKQBOk9yUqgnufRyyqXatsRHpesbM49rAkz0dD5XE80=";
  };

  cargoHash = "sha256-cwEHxbRFdOLmQy0FS4U6g785szMWISe6vkXvtj4VwPs=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage docs/man/kestrel.1
    installShellCompletion --bash --name kestrel completion/kestrel.bash-completion
  '';

  meta = with lib; {
    description = "File encryption done right";
    mainProgram = "kestrel";
    longDescription = "
      Kestrel is a data-at-rest file encryption program
      that lets you encrypt files to anyone with a public key.
    ";
    homepage = "https://getkestrel.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zendo ];
  };
}
