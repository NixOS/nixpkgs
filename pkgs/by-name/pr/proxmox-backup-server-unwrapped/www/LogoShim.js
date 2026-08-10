Ext.define('PMX.image.LogoSVG', {
    extend: 'Ext.Img',
    xtype: 'proxmoxLogoSvg',
    height: 35,
    width: 200,
    src: '/images/proxmox_logo.png',
    alt: 'Proxmox',
    autoEl: { tag: 'a', href: 'https://www.proxmox.com', target: '_blank' },
    initComponent: function () { let me = this; me.src = (me.prefix !== undefined ? me.prefix : "") + me.src; me.callParent(); },
});
