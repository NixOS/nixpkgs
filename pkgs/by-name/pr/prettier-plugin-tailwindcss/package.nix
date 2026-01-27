{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  prettier,
}:

buildNpmPackage rec {
  pname = "prettier-plugin-tailwindcss";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "prettier-plugin-tailwindcss";
    rev = "v${version}";
    hash = "sha256-/zRz0mP2P8xX8n0UQmzWt0eYNYA5S4RrD0lRzQYt03M=";
  };

  npmDepsHash = "sha256-J2TTD4rsEG2CYtGWfksbGdTD/yFOX/WeVwaUdlyjuPQ=";

  # Prettier plugin for Tailwind CSS fail to resolve prettier dependency
  postInstall = ''
    mkdir -p $out/lib/node_modules/prettier-plugin-tailwindcss/node_modules
    ln -s ${prettier}/lib/node_modules/prettier $out/lib/node_modules/prettier-plugin-tailwindcss/node_modules/prettier
  '';

  meta = with lib; {
    description = "Prettier plugin for Tailwind CSS";
    homepage = "https://github.com/tailwindlabs/prettier-plugin-tailwindcss";
    license = licenses.mit;
    maintainers = with maintainers; [ shikanime ];
  };
}
