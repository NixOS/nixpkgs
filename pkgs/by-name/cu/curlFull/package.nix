{
  curl,
  ...
}@args:

curl.override (
  {
    c-aresSupport = true;
    ldapSupport = true;
    gsaslSupport = true;
  }
  // removeAttrs args [ "curl" ]
)
