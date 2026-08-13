config :mime, :types, %{
  "application/xml" => ["xml"],
  "application/xrd+xml" => ["xrd+xml"],
  "application/jrd+json" => ["jrd+json"],
  "application/activity+json" => ["activity+json"],
  "application/ld+json" => ["activity+json"],
  "image/apng" => ["apng"]
}

config :mime, :extensions, %{
  "xrd+xml" => "text/plain",
  "jrd+json" => "text/plain",
  "activity+json" => "text/plain"
}
