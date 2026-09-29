const anchor = document.location.hash.substring(1);
const redirects = REDIRECTS_PLACEHOLDER;
if (redirects[anchor]) document.location.href = redirects[anchor];
