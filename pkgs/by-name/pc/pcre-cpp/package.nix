{
  pcre,
  ...
}@args:

pcre.override (
  {
    variant = "cpp";
  }
  // removeAttrs args [ "pcre" ]
)
