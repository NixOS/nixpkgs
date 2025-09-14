{
  version,
  fetchzip,
  meta,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "resource-types";
  meta = meta // {
    description = "Resource types for concourse worker";
  };
  inherit version;
  src =
    fetchzip
      {
        aarch64-linux = {
          url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-arm64.tgz";
          hash = "sha256-BPCg3ZCvtUtuJ1JBXMaozwkjWF0ZoJbV6GMzPWVYqN8=";
        };
        x86_64-linux = {
          url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-amd64.tgz";
          hash = "sha256-lFnBibUj4/53qZe0JZLqzMeirgmyW881kaOBFzVdEzg=";
        };
        x86_64-darwin = {
          url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-darwin-amd64.tgz";
          hash = "sha256-x03ALo0wA6jiUtdkktLsnUZIUk1VBJGkhUMLXhvNnlY=";
        };
        aarch64-darwin = {
          url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-darwin-arm64.tgz";
          hash = "sha256-IxhgePX9nqVhR24kkVtWECpyiR3UBMJLWNiAzAN4xnU=";
        };
      }
      .${stdenv.hostPlatform.system};
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    mv resource-types/* $out/
  '';
}
