{
  kuma,
  ...
}@args:

kuma.override (
  {
    pname = "kuma-experimental";
    isFull = true;
    enableGateway = true;

  }
  // removeAttrs args [ "kuma" ]
)
