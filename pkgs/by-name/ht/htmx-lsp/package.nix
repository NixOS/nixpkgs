{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "htmx-lsp";
  version = "0.1.0-unstable-2025-06-14";

  src = fetchFromGitHub {
    owner = "ThePrimeagen";
    repo = "htmx-lsp";
    rev = "c45f55b2bf8be2d92489fd6d69a3db07fe5f214b";
    hash = "sha256-7CAlYYwsanlOCGeY7gYE5Fzk5IEO4hThgINiJmXql7s=";
  };

  cargoHash = "sha256-/ypaTrctJo88DHtF/hv6B0dqB06axd/qKFnuI8zs8KA=";

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Language server implementation for htmx";
    homepage = "https://github.com/ThePrimeagen/htmx-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "htmx-lsp";
  };
}
