{ lib, poetry2nix, fetchFromGitHub }:

poetry2nix.mkPoetryApplication rec {
  pname = "harlequin";
  version = "1.1.1";
  projectDir = src;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    rev = "v${version}";
    hash = "sha256-JxTcUiytDXK8Ozx8lmy/ypXIL3zW8GK+xaec7XMmnfE=";
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/tconbeer/harlequin";
    description = "The DuckDB IDE for your terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ sanityinc ];
    platforms = platforms.unix;
  };
}
