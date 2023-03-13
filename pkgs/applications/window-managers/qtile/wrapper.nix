{ python3, qtile-unwrapped }:
(python3.withPackages (_: [ qtile-unwrapped ])).overrideAttrs (_: {
  # otherwise will be exported as "env", this restores `nix search` behavior
  name = "${qtile-unwrapped.pname}-${qtile-unwrapped.version}";
  # export underlying qtile package
  passthru = { unwrapped = qtile-unwrapped; };
  # restore original qtile attrs
  inherit (qtile-unwrapped) pname version meta;
})
