{
  lib,
  fetchurl,
  makeWrapper,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "ansible-language-server";
  version = "1.2.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-${version}.tgz";
    hash = "sha256-MYKWCjXyKfRT1SDPtsliTKGBBGU0V+ypncFAZpD6WqI=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./deps.json} package-lock.json
  '';

  npmDepsHash = "sha256-e7n7C9LBoS9JVk/ZlKX8iJkBeKy+0MVGb+uQNGm+O30=";

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Clean up npm's scoped package bin directory structure
    rm -rf $out/bin/@ansible
    rm -f $out/bin/ansible-language-server

    # Create a clean wrapper using the npm package's bin script
    # which properly handles --version
    makeWrapper $out/lib/node_modules/@ansible/ansible-language-server/bin/ansible-language-server \
      $out/bin/ansible-language-server
  '';

  meta = with lib; {
    description = "Ansible language server";
    homepage = "https://github.com/ansible/vscode-ansible";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "ansible-language-server";
  };
}
