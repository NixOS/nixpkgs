def truncate(xs; n):
  if xs | length > n then xs[:n] + ["..."]
  else xs
  end;

def itemize_packages(xs):
  truncate(xs; 2000) |
    map("- [\(.)](https://search.nixos.org/packages?channel=unstable&show=\(.)&from=0&size=50&sort=relevance&type=packages&query=\(.))")  |
    join("\n");

def get_title(s; xs):
  s + " (" + (xs | length | tostring) + ")";

def section(title; xs):
  "<details> <summary>" + get_title(title; xs) + "</summary>\n\n" + itemize_packages(xs) + "</details>";

def fallback_document(content; n):
  if content | utf8bytelength > n then
    get_title("Added packages"; .attrdiff.added) + "\n\n" +
    get_title("Removed packages"; .attrdiff.removed) + "\n\n" +
    get_title("Changed packages"; .attrdiff.changed)
  else content
  end;

# we truncate the list to stay below the GitHub limit of 1MB per step summary.
fallback_document(
  section("Added packages"; .attrdiff.added) + "\n\n" +
  section("Removed packages"; .attrdiff.removed) + "\n\n" +
  section("Changed packages"; .attrdiff.changed); 1000 * 1000
)
