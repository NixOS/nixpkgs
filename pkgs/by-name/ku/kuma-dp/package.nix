{
  kuma,
  ...
}@args:

kuma.override (
  {
    pname = "kuma-dp";
    isFull = false;
    components = [ "kuma-dp" ];
  }
  // removeAttrs args [ "kuma" ]
)
