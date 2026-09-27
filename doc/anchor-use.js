document.addEventListener('DOMContentLoaded', () => {
  anchors.add(
    'h1[id]:not(div.note h1, div.warning h1, div.tip h1, div.caution h1, div.important h1), h2[id]:not(div.note h2, div.warning h2, div.tip h2, div.caution h2, div.important h2), h3[id]:not(div.note h3, div.warning h3, div.tip h3, div.caution h3, div.important h3), h4[id]:not(div.note h4, div.warning h4, div.tip h4, div.caution h4, div.important h4), h5[id]:not(div.note h5, div.warning h5, div.tip h5, div.caution h5, div.important h5), h6[id]:not(div.note h6, div.warning h6, div.tip h6, div.caution h6, div.important h6)',
  )
})
