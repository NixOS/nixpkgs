/* This file is NOT part of highlight.js */
document.addEventListener('DOMContentLoaded', (event) => {
    document.querySelectorAll('.programlisting, .screen').forEach((element) => {
        hljs.highlightElement(element);
    });
});
