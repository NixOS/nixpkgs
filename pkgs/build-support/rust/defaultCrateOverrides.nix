{ pkgs, ... }:

with pkgs;
{
  libsqlite3-sys = attrs: { buildInputs = [ pkgconfig sqlite ] ++ (attrs.buildInputs or []); };
  openssl-sys = attrs: { buildInputs = [ pkgconfig openssl ] ++ (attrs.buildInputs or []); };
}
