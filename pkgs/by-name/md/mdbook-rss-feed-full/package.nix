{
  mdbook-rss-feed,
  ...
}@args:

mdbook-rss-feed.override (
  {
    withAtom = true;
    withJsonFeed = true;
  }
  // removeAttrs args [ "mdbook-rss-feed" ]
)
