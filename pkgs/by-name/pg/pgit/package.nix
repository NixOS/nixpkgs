{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  git, # for passthru tests
  pgit, # for passthru tests
}:

buildGoModule (finalAttrs: {
  pname = "pgit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "picosh";
    repo = "pgit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W+vnlplSVV1oZYQ4Fw4gfm0c1CP3fj9tXmqUmk5EhrI=";
  };

  vendorHash = "sha256-in8GVcOlGsvmcbegJmYwvE0AVJhVJ83x1v3ymV0uTpg=";

  passthru.tests.smoke =
    runCommand "pgit-smoke-test"
      {
        buildInputs = [ git ];
      }
      ''
        ${lib.getExe git} init -b smoke
        ${lib.getExe git} config --local user.name "Nick Spackages"
        ${lib.getExe git} config --local user.email "nixbld@localhost"
        echo "Read me please" > README
        ${lib.getExe git} add README
        ${lib.getExe git} commit -m "First commit"
        ${lib.getExe pgit} -revs smoke -repo . -out ./public
        grep "First commit" ./public/logs/smoke/index.html
        grep "Read me please" ./public/tree/smoke/item/README.html
        touch $out
      '';

  meta = {
    description = "static site generator for git";
    homepage = "https://pgit.pico.sh/";
    license = lib.licenses.mit;
    mainProgram = "pgit";
    maintainers = with lib.maintainers; [ jaculabilis ];
  };
})
