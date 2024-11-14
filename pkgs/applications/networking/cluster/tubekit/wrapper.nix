{ runCommand
, makeWrapper
, tubekit-unwrapped
, pname ? "tubekit"
, version ? tubekit-unwrapped.version
, kubectl
}:
runCommand "${pname}-${version}"
{
  inherit pname version;
  inherit (tubekit-unwrapped) src meta;
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${tubekit-unwrapped}/bin/tubectl $out/bin/tubectl --set-default TUBEKIT_KUBECTL ${kubectl}/bin/kubectl
''
