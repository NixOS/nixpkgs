/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once

#include "Job.h"

#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    /* welcome */
    Q_PROPERTY( QString osName READ osName CONSTANT FINAL )
    Q_PROPERTY( QString arch READ arch CONSTANT FINAL )
    Q_PROPERTY( QString device READ device CONSTANT FINAL )
    Q_PROPERTY( QString userInterface READ userInterface CONSTANT FINAL )
    Q_PROPERTY( QString version READ version CONSTANT FINAL )

    /* default user */
    Q_PROPERTY( QString username READ username CONSTANT FINAL )
    Q_PROPERTY( QString userPassword READ userPassword WRITE setUserPassword NOTIFY userPasswordChanged )

    /* ssh server + credentials */
    Q_PROPERTY( bool featureSshd READ featureSshd CONSTANT FINAL )
    Q_PROPERTY( QString sshdUsername READ sshdUsername WRITE setSshdUsername NOTIFY sshdUsernameChanged )
    Q_PROPERTY( QString sshdPassword READ sshdPassword WRITE setSshdPassword NOTIFY sshdPasswordChanged )
    Q_PROPERTY( bool isSshEnabled READ isSshEnabled WRITE setIsSshEnabled )

    /* full disk encryption */
    Q_PROPERTY( QString fdePassword READ fdePassword WRITE setFdePassword NOTIFY fdePasswordChanged )
    Q_PROPERTY( bool isFdeEnabled READ isFdeEnabled WRITE setIsFdeEnabled )

    /* filesystem selection */
    Q_PROPERTY( QString fsType READ fsType WRITE setFsType NOTIFY fsTypeChanged )
    Q_PROPERTY( bool featureFsType READ featureFsType CONSTANT FINAL )
    Q_PROPERTY( QStringList fsList READ fsList CONSTANT FINAL )
    Q_PROPERTY( QString defaultFs READ defaultFs CONSTANT FINAL )
    Q_PROPERTY( int fsIndex READ fsIndex WRITE setFsIndex NOTIFY fsIndexChanged )

    /* partition job */
    Q_PROPERTY( bool runPartitionJobThenLeave READ runPartitionJobThenLeaveDummy WRITE runPartitionJobThenLeave )
    Q_PROPERTY( QString cmdInternalStoragePrepare READ cmdInternalStoragePrepare CONSTANT FINAL )
    Q_PROPERTY( QString cmdLuksFormat READ cmdLuksFormat CONSTANT FINAL )
    Q_PROPERTY( QString cmdLuksOpen READ cmdLuksOpen CONSTANT FINAL )
    Q_PROPERTY( QString cmdMount READ cmdMount CONSTANT FINAL )
    Q_PROPERTY( QString targetDeviceRoot READ targetDeviceRoot CONSTANT FINAL )
    Q_PROPERTY( QString targetDeviceRootInternal READ targetDeviceRootInternal CONSTANT FINAL )
    Q_PROPERTY(
        bool installFromExternalToInternal READ installFromExternalToInternal WRITE setInstallFromExternalToInternal )

    /* users job */
    Q_PROPERTY( QString cmdSshdEnable READ cmdSshdEnable CONSTANT FINAL )
    Q_PROPERTY( QString cmdSshdDisable READ cmdSshdDisable CONSTANT FINAL )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );
    Calamares::JobList createJobs();

    /* welcome */
    QString osName() const { return m_osName; }
    QString arch() const { return m_arch; }
    QString device() const { return m_device; }
    QString userInterface() const { return m_userInterface; }
    QString version() const { return m_version; }

    /* default user */
    QString username() const { return m_username; }
    QString userPassword() const { return m_userPassword; }
    void setUserPassword( const QString& userPassword );

    /* ssh server + credetials */
    bool featureSshd() { return m_featureSshd; }
    QString sshdUsername() const { return m_sshdUsername; }
    QString sshdPassword() const { return m_sshdPassword; }
    bool isSshEnabled() { return m_isSshEnabled; }
    void setSshdUsername( const QString& sshdUsername );
    void setSshdPassword( const QString& sshdPassword );
    void setIsSshEnabled( bool isSshEnabled );

    /* full disk encryption */
    QString fdePassword() const { return m_fdePassword; }
    bool isFdeEnabled() { return m_isFdeEnabled; }
    void setFdePassword( const QString& fdePassword );
    void setIsFdeEnabled( bool isFdeEnabled );

    /* filesystem selection */
    bool featureFsType() { return m_featureFsType; };
    QString fsType() const { return m_fsType; };
    void setFsType( int idx );
    void setFsType( const QString& fsType );
    QStringList fsList() const { return m_fsList; };
    int fsIndex() const { return m_fsIndex; };
    void setFsIndex( const int fsIndex );
    QString defaultFs() const { return m_defaultFs; };

    /* partition job */
    bool runPartitionJobThenLeaveDummy() { return 0; }
    void runPartitionJobThenLeave( bool b );
    QString cmdInternalStoragePrepare() const { return m_cmdInternalStoragePrepare; }
    QString cmdLuksFormat() const { return m_cmdLuksFormat; }
    QString cmdLuksOpen() const { return m_cmdLuksOpen; }
    QString cmdMkfsRootBtrfs() const { return m_cmdMkfsRootBtrfs; }
    QString cmdMkfsRootExt4() const { return m_cmdMkfsRootExt4; }
    QString cmdMkfsRootF2fs() const { return m_cmdMkfsRootF2fs; }
    QString cmdMount() const { return m_cmdMount; }
    QString targetDeviceRoot() const { return m_targetDeviceRoot; }
    QString targetDeviceRootInternal() const { return m_targetDeviceRootInternal; }
    bool installFromExternalToInternal() { return m_installFromExternalToInternal; }
    void setInstallFromExternalToInternal( const bool val );

    /* users job */
    QString cmdPasswd() const { return m_cmdPasswd; }
    QString cmdSshdEnable() const { return m_cmdSshdEnable; }
    QString cmdSshdDisable() const { return m_cmdSshdDisable; }
    QString cmdSshdUseradd() const { return m_cmdSshdUseradd; }

private:
    /* welcome */
    QString m_osName;
    QString m_arch;
    QString m_device;
    QString m_userInterface;
    QString m_version;

    /* default user */
    QString m_username;
    QString m_userPassword;

    /* ssh server + credetials */
    bool m_featureSshd;
    QString m_sshdUsername;
    QString m_sshdPassword;
    bool m_isSshEnabled;

    /* full disk encryption */
    QString m_fdePassword = "";
    bool m_isFdeEnabled = false;

    /* filesystem selection */
    bool m_featureFsType;
    QString m_defaultFs;
    QString m_fsType;
    // Index of the currently selected filesystem in UI.
    int m_fsIndex;
    QStringList m_fsList;

    /* partition job */
    QString m_cmdInternalStoragePrepare;
    QString m_cmdLuksFormat;
    QString m_cmdLuksOpen;
    QString m_cmdMkfsRootBtrfs;
    QString m_cmdMkfsRootExt4;
    QString m_cmdMkfsRootF2fs;
    QString m_cmdMount;
    QString m_targetDeviceRoot;
    QString m_targetDeviceRootInternal;
    bool m_installFromExternalToInternal;

    /* users job */
    QString m_cmdPasswd;
    QString m_cmdSshdEnable;
    QString m_cmdSshdDisable;
    QString m_cmdSshdUseradd;

signals:
    /* booleans we don't read from QML (like isSshEnabled) don't need a signal */

    /* default user */
    void userPasswordChanged( QString userPassword );

    /* ssh server + credentials */
    void sshdUsernameChanged( QString sshdUsername );
    void sshdPasswordChanged( QString sshdPassword );

    /* full disk encryption */
    void fdePasswordChanged( QString fdePassword );

    void fsTypeChanged( QString fsType );
    void fsIndexChanged( int fsIndex );
};
