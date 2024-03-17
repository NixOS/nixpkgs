{ lib
, libsolv
}:
(libsolv.overrideAttrs {
  meta.maintainers = [ lib.maintainers.ericthemagician ];
}).override {
  withConda = true;
}


