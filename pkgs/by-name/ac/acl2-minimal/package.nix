{
  acl2,
  ...
}@args:

acl2.override (
  {
    certifyBooks = false;
  }
  // removeAttrs args [ "acl2" ]
)
